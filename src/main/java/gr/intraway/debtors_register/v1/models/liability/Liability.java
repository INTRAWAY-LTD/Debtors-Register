package gr.intraway.debtors_register.v1.models.liability;

import gr.intraway.debtors_register.v1.models.users.Department;
import gr.intraway.debtors_register.v1.models.users.User;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import java.math.BigDecimal;
import java.time.LocalDate;

@Getter
@Setter
@Entity
@Table(name = "LIABILITY")
public class Liability {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID", nullable = false)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @OnDelete(action = OnDeleteAction.RESTRICT)
    @JoinColumn(name = "USER_ID", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @OnDelete(action = OnDeleteAction.RESTRICT)
    @JoinColumn(name = "DEPARTMENT_ID", nullable = false)
    private Department department;

    @Column(name = "ASSESSMENT_DECISION_ACT_NUMBER", nullable = false)
    private String assessmentDecisionActNumber;

    @Column(name = "ASSESSMENT_ISSUANCE_DATE", nullable = false)
    private LocalDate assessmentIssuanceDate;

    @Column(name = "AMOUNT", nullable = false, precision = 15, scale = 2)
    private BigDecimal amount;

    @Column(name = "UNDUE_PERIOD_FROM")
    private LocalDate unduePeriodFrom;

    @Column(name = "UNDUE_PERIOD_TO")
    private LocalDate unduePeriodTo;

    @Column(name = "RF", length = 25)
    private String rf;

    @Column(name = "OBJECTION_DEADLINE")
    private LocalDate objectionDeadline;

    @Column(name = "BALANCE", precision = 15, scale = 2)
    private BigDecimal balance;

    @Column(name = "FINALIZATION_DATE")
    private LocalDate finalizationDate;

    @ManyToOne(fetch = FetchType.LAZY)
    @OnDelete(action = OnDeleteAction.RESTRICT)
    @JoinColumn(name = "REPLACED_LIABILITY_ID")
    private Liability replacedLiability;

    @Column(name = "COMMENTS", length = 4000)
    private String comments;

    @ColumnDefault("'OBJECTION_PERIOD'")
    @Column(name = "STATUS", nullable = false, length = 30)
    private String status;

    @ColumnDefault("'UNPAID'")
    @Column(name = "PAYMENT_STATUS", nullable = false, length = 30)
    private String paymentStatus;

    @ColumnDefault("'NONE'")
    @Column(name = "ARRANGEMENT_STATUS", nullable = false, length = 30)
    private String arrangementStatus;

    @ColumnDefault("'NOT_TRANSFERRED'")
    @Column(name = "TAX_OFFICE_STATUS", nullable = false, length = 30)
    private String taxOfficeStatus;

}