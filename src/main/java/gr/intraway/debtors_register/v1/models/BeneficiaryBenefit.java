package gr.intraway.debtors_register.v1.models;

import gr.intraway.debtors_register.v1.models.users.Department;
import gr.intraway.debtors_register.v1.models.users.User;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import java.time.Instant;
import java.time.LocalDate;

@Getter
@Setter
@Entity
@Table(name = "BENEFICIARY_BENEFIT")
public class BeneficiaryBenefit {
    @EmbeddedId
    private BeneficiaryBenefitId id;

    @MapsId("userId")
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @OnDelete(action = OnDeleteAction.RESTRICT)
    @JoinColumn(name = "USER_ID", nullable = false)
    private User user;

    @MapsId("departmentId")
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @OnDelete(action = OnDeleteAction.RESTRICT)
    @JoinColumn(name = "DEPARTMENT_ID", nullable = false)
    private Department department;

    @Column(name = "ENTITLEMENT_START_DATE")
    private LocalDate entitlementStartDate;

    @Column(name = "SOURCE", nullable = false, length = 30)
    private String source;

    @ColumnDefault("CURRENT_TIMESTAMP")
    @Column(name = "CREATED_AT", nullable = false)
    private Instant createdAt;

}