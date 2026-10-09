package gr.intraway.debtors_register.v1.models;

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
@Table(name = "ALLOWANCE_PAYMENT")
public class AllowancePayment {
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

    @Column(name = "REFERENCE_PERIOD", nullable = false)
    private LocalDate referencePeriod;

    @Column(name = "AMOUNT", nullable = false, precision = 15, scale = 2)
    private BigDecimal amount;

    @Column(name = "IBAN", nullable = false, length = 34)
    private String iban;

    @Column(name = "APPROVAL_DATE", nullable = false)
    private LocalDate approvalDate;

    @Column(name = "EXECUTION_DATE")
    private LocalDate executionDate;

    @Column(name = "REJECTION_REASON", length = 4000)
    private String rejectionReason;

    @ColumnDefault("'REGISTERED'")
    @Column(name = "STATUS", nullable = false, length = 30)
    private String status;

}