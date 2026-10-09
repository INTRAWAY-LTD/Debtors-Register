package gr.intraway.debtors_register.v1.models;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.Hibernate;

import java.io.Serializable;
import java.util.Objects;

@Getter
@Setter
@Embeddable
public class BeneficiaryBenefitId implements Serializable {
    private static final long serialVersionUID = 1909526098368077856L;
    @Column(name = "USER_ID", nullable = false)
    private Long userId;

    @Column(name = "DEPARTMENT_ID", nullable = false)
    private Long departmentId;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || Hibernate.getClass(this) != Hibernate.getClass(o)) return false;
        BeneficiaryBenefitId entity = (BeneficiaryBenefitId) o;
        return Objects.equals(this.departmentId, entity.departmentId) &&
                Objects.equals(this.userId, entity.userId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(departmentId, userId);
    }

}