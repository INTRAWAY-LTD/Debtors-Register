-- Προνοιακό Τμήμα / Παροχή (παραμετρικός κατάλογος, UC-03)
CREATE TABLE department (
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    code varchar2(10) NOT NULL UNIQUE, -- Κωδικός Τμήματος (χρησιμοποιείται και στη δομή του RF)
    name varchar2(150) NOT NULL UNIQUE, -- Ονομασία
    benefit varchar2(255) NOT NULL, -- Παροχή
    category varchar2(150) NULL, -- Κατηγορία (Οικογένεια, Άτομα με Αναπηρία, ...)
    directorate varchar2(255) NULL, -- Διεύθυνση
    revenue_account varchar2(50) NULL, -- ΚΑΕ / λογαριασμός είσπραξης για το Λογιστήριο
    active NUMBER(1) DEFAULT 1 NOT NULL CHECK (active IN (0, 1)) -- Ενεργό / ανενεργό
);

-- Χρήστες (δικαιούχοι και διαχειριστές)
CREATE TABLE users (
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, -- Αριθμός Μητρώου
    username varchar2(255) NULL,
    email varchar2(255) NULL, -- οι δικαιούχοι από ΗΔΙΚΑ δεν έχουν email
    afm VARCHAR2(9) NULL, -- όχι UNIQUE: ίδιος ΑΦΜ με διαφορετικό ΑΜΚΑ είναι πιθανή διπλοεγγραφή (UC-13)
    amka VARCHAR2(11) UNIQUE NOT NULL,
    first_name varchar2(150) NOT NULL,
    last_name varchar2(150) NOT NULL,
    father_name varchar2(255) NOT NULL,
    mother_name varchar2(255) NOT NULL,
    birth_date DATE NOT NULL,
    deceased NUMBER(1) DEFAULT 0 NOT NULL CHECK (deceased IN (0, 1)), -- Ένδειξη θανόντος
    death_date DATE NULL,
    address varchar2(255) NULL, -- Διεύθυνση κατοικίας / επικοινωνίας
    phone_number varchar2(50) NULL,
    role varchar2(150) NOT NULL,
    status varchar2(150) DEFAULT 'active' NOT NULL,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP NULL,
    updated_at timestamp DEFAULT CURRENT_TIMESTAMP NULL,
    password_changed_at TIMESTAMP NULL,
    last_login timestamp NULL,
    deleted_at timestamp NULL,
    registration_source varchar2(255) NULL, -- Αρχική φόρτωση · Ενημέρωση ΗΔΙΚΑ · Άντληση ΑΜΚΑ
    -- Ένδειξη ελέγχου / ενοποίησης (UC-13): Κανονική · Προς έλεγχο · Ενοποιημένη
    merge_status varchar2(30) DEFAULT 'NONE' NOT NULL,
    merged_into_user_id NUMBER NULL REFERENCES users(id), -- Κύρια μερίδα όταν η μερίδα έχει ενοποιηθεί
    CONSTRAINT chk_user_amka CHECK (REGEXP_LIKE(amka, '^[0-9]{11}$')),
    CONSTRAINT chk_user_afm CHECK (afm IS NULL OR REGEXP_LIKE(afm, '^[0-9]{9}$')),
    CONSTRAINT chk_user_death_date CHECK (death_date IS NULL OR death_date >= birth_date),
    CONSTRAINT chk_user_merge_status CHECK (merge_status IN ('NONE', 'FOR_REVIEW', 'MERGED')),
    CONSTRAINT chk_user_merged_into CHECK (
        (merge_status = 'MERGED' AND merged_into_user_id IS NOT NULL)
        OR (merge_status <> 'MERGED' AND merged_into_user_id IS NULL)
    )
);

-- Τμήματα στα οποία έχει πρόσβαση ο Χρήστης Τμήματος (ορατότητα)
CREATE TABLE user_department (
    user_id NUMBER NOT NULL REFERENCES users(id),
    department_id NUMBER NOT NULL REFERENCES department(id),
    created_at timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT pk_user_department PRIMARY KEY (user_id, department_id)
);

-- Παροχές του δικαιούχου: Τμήματα στα οποία έχει ή είχε δικαίωμα (UC-10, UC-11)
CREATE TABLE beneficiary_benefit (
    user_id NUMBER NOT NULL REFERENCES users(id),
    department_id NUMBER NOT NULL REFERENCES department(id),
    entitlement_start_date DATE NULL, -- Ημερομηνία έναρξης δικαιώματος (Η1)
    source varchar2(30) NOT NULL, -- Πηγή: Αρχική φόρτωση · Ενημέρωση ΗΔΙΚΑ · Άντληση ΑΜΚΑ
    created_at timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT pk_beneficiary_benefit PRIMARY KEY (user_id, department_id),
    CONSTRAINT chk_beneficiary_benefit_source CHECK (source IN ('INITIAL_LOAD', 'IDIKA_UPDATE', 'AMKA_LOOKUP'))
);

-- Οφειλές
CREATE TABLE liability (
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, -- Αριθμός οφειλής
    user_id NUMBER NOT NULL REFERENCES users(id), -- απο εδω παιρνουμε ΑΦΜ, ΑΜΚΑ, ον/μο
    department_id NUMBER NOT NULL REFERENCES department(id), -- Τμήμα / Παροχή
    assessment_decision_act_number varchar2(255) NOT NULL, -- Αριθμός καταλογιστικής πράξης απόφασης
    assessment_issuance_date DATE NOT NULL, -- Ημερομηνία έκδοσης καταλογιστικής
    amount NUMBER(15, 2) NOT NULL, -- Ποσό
    undue_period_from DATE NULL, -- Περίοδος αχρεωστήτως από
    undue_period_to DATE NULL, -- Περίοδος αχρεωστήτως έως
    rf varchar2(25) UNIQUE NULL, -- Ταυτότητα Οφειλής (ISO 11649)
    objection_deadline DATE NULL, -- Λήξη περιόδου ένστασης
    balance NUMBER(15, 2) NULL, -- Υπόλοιπο
    finalization_date DATE NULL, -- Ημερομηνία οριστικοποίησης
    replaced_liability_id NUMBER NULL REFERENCES liability(id), -- Συνδεδεμένη ακυρωμένη οφειλή
    comments varchar2(4000) NULL, -- Σχόλια
    -- Κύρια κατάσταση: Σε περίοδο ένστασης · Ένσταση σε εξέταση · Οριστικοποιημένη · Ακυρωμένη · Ακυρωμένη λόγω λάθους
    status varchar2(30) DEFAULT 'OBJECTION_PERIOD' NOT NULL,
    -- Εξόφληση: Ανεξόφλητη · Μερικώς εξοφλημένη · Εξοφλημένη · Υπερπληρωμή
    payment_status varchar2(30) DEFAULT 'UNPAID' NOT NULL,
    -- Ρύθμιση: Χωρίς ρύθμιση · Σε ρύθμιση δόσεων · Απώλεια ρύθμισης · Ρύθμιση ολοκληρώθηκε
    arrangement_status varchar2(30) DEFAULT 'NONE' NOT NULL,
    -- ΔΟΥ: Μη διαβιβασμένη · Διαβιβάστηκε στη ΔΟΥ
    tax_office_status varchar2(30) DEFAULT 'NOT_TRANSFERRED' NOT NULL,
    CONSTRAINT uq_liability_assessment UNIQUE (department_id, assessment_decision_act_number), -- ΚΜ-2
    CONSTRAINT chk_liability_amount CHECK (amount > 0),
    CONSTRAINT chk_liability_status CHECK (
        status IN ('OBJECTION_PERIOD', 'OBJECTION_UNDER_REVIEW', 'FINALIZED', 'CANCELLED', 'CANCELLED_ERROR')
    ),
    CONSTRAINT chk_liability_payment_status CHECK (payment_status IN ('UNPAID', 'PARTIALLY_PAID', 'PAID', 'OVERPAID')),
    CONSTRAINT chk_liability_arrangement_status CHECK (
        arrangement_status IN ('NONE', 'IN_INSTALLMENTS', 'ARRANGEMENT_LOST', 'ARRANGEMENT_COMPLETED')
    ),
    CONSTRAINT chk_liability_tax_office_status CHECK (tax_office_status IN ('NOT_TRANSFERRED', 'TRANSFERRED')),
    CONSTRAINT chk_liability_undue_period CHECK (
        undue_period_from IS NULL OR undue_period_to IS NULL OR undue_period_from <= undue_period_to
    ),
    CONSTRAINT chk_liability_rf CHECK (rf IS NULL OR REGEXP_LIKE(rf, '^RF[0-9]{2}[0-9A-Z]{1,21}$'))
);

-- ΚΜ-1: μία ενεργή (μη εξοφλημένη, μη ακυρωμένη) οφειλή ανά πρόσωπο και Τμήμα
CREATE UNIQUE INDEX uq_liability_active_per_department ON liability (
    CASE WHEN status NOT IN ('CANCELLED', 'CANCELLED_ERROR') AND payment_status NOT IN ('PAID', 'OVERPAID') THEN user_id END,
    CASE WHEN status NOT IN ('CANCELLED', 'CANCELLED_ERROR') AND payment_status NOT IN ('PAID', 'OVERPAID') THEN department_id END
);

-- Κίνηση Οφειλής
CREATE TABLE liability_action (
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    liability_id NUMBER NOT NULL REFERENCES liability(id),
    action_type varchar2(30) NOT NULL, -- Τύπος κίνησης: Είσπραξη RF · Συμψηφισμός · Αντιλογισμός
    source varchar2(30) NOT NULL, -- Πηγή: Λογιστήριο · Χρήστης Τμήματος
    amount NUMBER(15, 2) NOT NULL, -- Ποσό
    action_date DATE NOT NULL, -- Ημερομηνία πίστωσης ή συμψηφισμού
    accounting_transaction_id varchar2(255) UNIQUE NULL, -- Αναγνωριστικό κίνησης Λογιστηρίου (είσπραξη RF)
    bank varchar2(255) NULL, -- Τράπεζα (είσπραξη RF)
    offset_payment_reference varchar2(255) NULL, -- Πληρωμή / περίοδος συμψηφισμού
    reversed_action_id NUMBER NULL REFERENCES liability_action(id), -- Κίνηση που αντιλογίζεται
    justification varchar2(4000) NULL, -- Αιτιολογία / σχόλιο
    CONSTRAINT chk_liability_action_amount CHECK (amount > 0),
    CONSTRAINT chk_liability_action_type CHECK (action_type IN ('RF_COLLECTION', 'OFFSET', 'REVERSAL')),
    CONSTRAINT chk_liability_action_source CHECK (source IN ('ACCOUNTING', 'DEPARTMENT_USER')),
    CONSTRAINT chk_liability_action_rf_collection CHECK (
        action_type <> 'RF_COLLECTION' OR accounting_transaction_id IS NOT NULL
    ),
    CONSTRAINT chk_liability_action_offset CHECK (
        action_type <> 'OFFSET' OR (offset_payment_reference IS NOT NULL AND justification IS NOT NULL)
    ),
    CONSTRAINT chk_liability_action_reversal CHECK (
        action_type <> 'REVERSAL' OR (reversed_action_id IS NOT NULL AND justification IS NOT NULL)
    )
);

-- Ένσταση
CREATE TABLE objection (
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    liability_id NUMBER NOT NULL REFERENCES liability(id),
    submission_date DATE NOT NULL, -- Ημερομηνία υποβολής ένστασης
    protocol_number varchar2(255) NOT NULL, -- Αριθμός πρωτοκόλλου ένστασης
    attachment BLOB NULL, -- Συνημμένο αντίγραφο (PDF)
    late_justification varchar2(4000) NULL, -- Αιτιολόγηση εκπρόθεσμης
    result varchar2(30) NULL, -- Αποτέλεσμα: Διατήρηση · Τροποποίηση · Ακύρωση
    decision_number varchar2(255) NULL, -- Αριθμός απόφασης επί ένστασης
    decision_date DATE NULL, -- Ημερομηνία απόφασης
    new_assessment_decision_act_number varchar2(255) NULL, -- Νέα καταλογιστική - αριθμός
    new_assessment_issuance_date DATE NULL, -- Νέα καταλογιστική - ημερομηνία
    new_amount NUMBER(15, 2) NULL, -- Νέο ποσό
    CONSTRAINT chk_objection_new_amount CHECK (new_amount IS NULL OR new_amount > 0),
    CONSTRAINT chk_objection_decision_date CHECK (decision_date IS NULL OR decision_date >= submission_date),
    CONSTRAINT chk_objection_result CHECK (result IS NULL OR result IN ('UPHELD', 'AMENDED', 'ANNULLED')),
    CONSTRAINT chk_objection_decision CHECK (
        result IS NULL OR (decision_number IS NOT NULL AND decision_date IS NOT NULL)
    ),
    CONSTRAINT chk_objection_amended CHECK (
        result IS NULL OR result <> 'AMENDED' OR (
            new_assessment_decision_act_number IS NOT NULL
            AND new_assessment_issuance_date IS NOT NULL
            AND new_amount IS NOT NULL
        )
    )
);

-- Πληρωμή Επιδόματος
CREATE TABLE allowance_payment (
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, -- Αριθμός πληρωμής
    user_id NUMBER NOT NULL REFERENCES users(id), -- ΑΜΚΑ
    department_id NUMBER NOT NULL REFERENCES department(id), -- Τμήμα / Παροχή
    reference_period DATE NOT NULL, -- Περίοδος αναφοράς (1η του μήνα)
    amount NUMBER(15, 2) NOT NULL, -- Ποσό
    iban varchar2(34) NOT NULL, -- IBAN
    approval_date DATE NOT NULL, -- Ημερομηνία έγκρισης
    execution_date DATE NULL, -- Ημερομηνία εκτέλεσης (Λ7)
    rejection_reason varchar2(4000) NULL, -- Αιτιολογία απόρριψης (Λ7)
    -- Κατάσταση: Καταχωρημένη · Απεστάλη στο Λογιστήριο · Εξοφλήθηκε · Απορρίφθηκε
    status varchar2(30) DEFAULT 'REGISTERED' NOT NULL,
    CONSTRAINT uq_allowance_payment_period UNIQUE (user_id, department_id, reference_period), -- διπλοεγγραφή
    CONSTRAINT chk_allowance_payment_amount CHECK (amount > 0),
    CONSTRAINT chk_allowance_payment_period CHECK (reference_period = TRUNC(reference_period, 'MM')),
    CONSTRAINT chk_allowance_payment_iban CHECK (REGEXP_LIKE(iban, '^[A-Z]{2}[0-9]{2}[0-9A-Z]{11,30}$')),
    CONSTRAINT chk_allowance_payment_status CHECK (status IN ('REGISTERED', 'SENT_TO_ACCOUNTING', 'PAID', 'REJECTED')),
    CONSTRAINT chk_allowance_payment_rejected CHECK (status <> 'REJECTED' OR rejection_reason IS NOT NULL)
);

-- Ρύθμιση σε δόσεις
CREATE TABLE installment_arrangement (
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    liability_id NUMBER NOT NULL REFERENCES liability(id), -- Οφειλή
    source varchar2(30) NOT NULL, -- Πηγή: Portal (πολίτης) · Τμήμα Εσόδων
    status varchar2(30) DEFAULT 'ACTIVE' NOT NULL, -- Ενεργή · Απώλεια ρύθμισης · Ολοκληρώθηκε · Ακυρώθηκε
    installment_count NUMBER(3) NOT NULL, -- Αριθμός δόσεων
    installment_amount NUMBER(15, 2) NULL, -- Ποσό δόσης
    first_installment_date DATE NULL, -- Ημερομηνία πρώτης δόσης
    justification varchar2(4000) NULL, -- Αιτιολογία
    CONSTRAINT chk_installment_arrangement_count CHECK (installment_count > 0),
    CONSTRAINT chk_installment_arrangement_amount CHECK (installment_amount IS NULL OR installment_amount > 0),
    CONSTRAINT chk_installment_arrangement_source CHECK (source IN ('PORTAL', 'REVENUE_DEPARTMENT')),
    CONSTRAINT chk_installment_arrangement_status CHECK (status IN ('ACTIVE', 'LOST', 'COMPLETED', 'CANCELLED'))
);

-- Μία ενεργή ρύθμιση ανά οφειλή
CREATE UNIQUE INDEX uq_installment_arrangement_active ON installment_arrangement (
    CASE WHEN status = 'ACTIVE' THEN liability_id END
);

-- Δόσεις ρύθμισης
CREATE TABLE installment (
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    installment_arrangement_id NUMBER NOT NULL REFERENCES installment_arrangement(id),
    installment_number NUMBER(3) NOT NULL, -- Αύξων αριθμός δόσης
    amount NUMBER(15, 2) NOT NULL, -- Ποσό δόσης (η τελευταία στρογγυλοποιεί)
    due_date DATE NOT NULL, -- Ημερομηνία λήξης
    status varchar2(30) DEFAULT 'OPEN' NOT NULL, -- Ανοιχτή · Εξοφλημένη · Ληξιπρόθεσμη
    CONSTRAINT uq_installment_number UNIQUE (installment_arrangement_id, installment_number),
    CONSTRAINT chk_installment_number CHECK (installment_number > 0),
    CONSTRAINT chk_installment_amount CHECK (amount > 0),
    CONSTRAINT chk_installment_status CHECK (status IN ('OPEN', 'PAID', 'OVERDUE'))
);

-- Ιστορικό Ενεργειών
CREATE TABLE audit_log (
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id NUMBER NULL REFERENCES users(id), -- NULL για ενέργειες του συστήματος
    entity_name varchar2(150) NOT NULL,
    entity_id NUMBER NOT NULL,
    action varchar2(150) NOT NULL,
    old_value CLOB NULL,
    new_value CLOB NULL,
    comments varchar2(4000) NULL,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL
);
