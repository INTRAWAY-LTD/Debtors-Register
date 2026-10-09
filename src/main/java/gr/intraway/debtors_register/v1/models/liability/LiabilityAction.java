package gr.intraway.debtors_register.v1.models.liability;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import java.math.BigDecimal;
import java.time.LocalDate;

@Getter
@Setter
@Entity
@Table(name = "LIABILITY_ACTION")
public class LiabilityAction {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID", nullable = false)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @OnDelete(action = OnDeleteAction.RESTRICT)
    @JoinColumn(name = "LIABILITY_ID", nullable = false)
    private Liability liability;

    @Column(name = "ACTION_TYPE", nullable = false, length = 30)
    private String actionType;

    @Column(name = "SOURCE", nullable = false, length = 30)
    private String source;

    @Column(name = "AMOUNT", nullable = false, precision = 15, scale = 2)
    private BigDecimal amount;

    @Column(name = "ACTION_DATE", nullable = false)
    private LocalDate actionDate;

    @Column(name = "ACCOUNTING_TRANSACTION_ID")
    private String accountingTransactionId;

    @Column(name = "BANK")
    private String bank;

    @Column(name = "OFFSET_PAYMENT_REFERENCE")
    private String offsetPaymentReference;

    @ManyToOne(fetch = FetchType.LAZY)
    @OnDelete(action = OnDeleteAction.RESTRICT)
    @JoinColumn(name = "REVERSED_ACTION_ID")
    private LiabilityAction reversedAction;

    @Column(name = "JUSTIFICATION", length = 4000)
    private String justification;

}