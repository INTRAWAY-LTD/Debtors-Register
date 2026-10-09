package gr.intraway.debtors_register.v1.models.users;

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
public class UserDepartmentId implements Serializable {
    private static final long serialVersionUID = 8309647154542697409L;
    @Column(name = "USER_ID", nullable = false)
    private Long userId;

    @Column(name = "DEPARTMENT_ID", nullable = false)
    private Long departmentId;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || Hibernate.getClass(this) != Hibernate.getClass(o)) return false;
        UserDepartmentId entity = (UserDepartmentId) o;
        return Objects.equals(this.departmentId, entity.departmentId) &&
                Objects.equals(this.userId, entity.userId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(departmentId, userId);
    }

}