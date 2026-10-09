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
@Table(name = "INSTALLMENT")
public class Installment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID", nullable = false)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @OnDelete(action = OnDeleteAction.RESTRICT)
    @JoinColumn(name = "INSTALLMENT_ARRANGEMENT_ID", nullable = false)
    private InstallmentArrangement installmentArrangement;

    @Column(name = "INSTALLMENT_NUMBER", nullable = false)
    private Short installmentNumber;

    @Column(name = "AMOUNT", nullable = false, precision = 15, scale = 2)
    private BigDecimal amount;

    @Column(name = "DUE_DATE", nullable = false)
    private LocalDate dueDate;

    @ColumnDefault("'OPEN'")
    @Column(name = "STATUS", nullable = false, length = 30)
    private String status;

}