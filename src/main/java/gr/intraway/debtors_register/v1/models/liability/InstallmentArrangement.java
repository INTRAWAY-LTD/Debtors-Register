package gr.intraway.debtors_register.v1.models.liability;

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
@Table(name = "INSTALLMENT_ARRANGEMENT")
public class InstallmentArrangement {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID", nullable = false)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @OnDelete(action = OnDeleteAction.RESTRICT)
    @JoinColumn(name = "LIABILITY_ID", nullable = false)
    private Liability liability;

    @Column(name = "SOURCE", nullable = false, length = 30)
    private String source;

    @ColumnDefault("'ACTIVE'")
    @Column(name = "STATUS", nullable = false, length = 30)
    private String status;

    @Column(name = "INSTALLMENT_COUNT", nullable = false)
    private Short installmentCount;

    @Column(name = "INSTALLMENT_AMOUNT", precision = 15, scale = 2)
    private BigDecimal installmentAmount;

    @Column(name = "FIRST_INSTALLMENT_DATE")
    private LocalDate firstInstallmentDate;

    @Column(name = "JUSTIFICATION", length = 4000)
    private String justification;

}