package gr.intraway.debtors_register.v1.models.users;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;

@Getter
@Setter
@Entity
@Table(name = "DEPARTMENT")
public class Department {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID", nullable = false)
    private Long id;

    @Column(name = "CODE", nullable = false, length = 10)
    private String code;

    @Column(name = "NAME", nullable = false, length = 150)
    private String name;

    @Column(name = "BENEFIT", nullable = false)
    private String benefit;

    @Column(name = "CATEGORY", length = 150)
    private String category;

    @Column(name = "DIRECTORATE")
    private String directorate;

    @Column(name = "REVENUE_ACCOUNT", length = 50)
    private String revenueAccount;

    @ColumnDefault("1")
    @Column(name = "ACTIVE", nullable = false)
    private Boolean active = false;

}