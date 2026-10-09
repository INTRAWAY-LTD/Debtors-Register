package gr.intraway.debtors_register.v1.models.users;

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
@Table(name = "USERS")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID", nullable = false)
    private Long id;

    @Column(name = "USERNAME")
    private String username;

    @Column(name = "EMAIL")
    private String email;

    @Column(name = "AFM", length = 9)
    private String afm;

    @Column(name = "AMKA", nullable = false, length = 11)
    private String amka;

    @Column(name = "FIRST_NAME", nullable = false, length = 150)
    private String firstName;

    @Column(name = "LAST_NAME", nullable = false, length = 150)
    private String lastName;

    @Column(name = "FATHER_NAME", nullable = false)
    private String fatherName;

    @Column(name = "MOTHER_NAME", nullable = false)
    private String motherName;

    @Column(name = "BIRTH_DATE", nullable = false)
    private LocalDate birthDate;

    @ColumnDefault("0")
    @Column(name = "DECEASED", nullable = false)
    private Boolean deceased = false;

    @Column(name = "DEATH_DATE")
    private LocalDate deathDate;

    @Column(name = "ADDRESS")
    private String address;

    @Column(name = "PHONE_NUMBER", length = 50)
    private String phoneNumber;

    @Column(name = "ROLE", nullable = false, length = 150)
    private String role;

    @ColumnDefault("'active'")
    @Column(name = "STATUS", nullable = false, length = 150)
    private String status;

    @ColumnDefault("CURRENT_TIMESTAMP")
    @Column(name = "CREATED_AT")
    private Instant createdAt;

    @ColumnDefault("CURRENT_TIMESTAMP")
    @Column(name = "UPDATED_AT")
    private Instant updatedAt;

    @Column(name = "PASSWORD_CHANGED_AT")
    private Instant passwordChangedAt;

    @Column(name = "LAST_LOGIN")
    private Instant lastLogin;

    @Column(name = "DELETED_AT")
    private Instant deletedAt;

    @Column(name = "REGISTRATION_SOURCE")
    private String registrationSource;

    @ColumnDefault("'NONE'")
    @Column(name = "MERGE_STATUS", nullable = false, length = 30)
    private String mergeStatus;

    @ManyToOne(fetch = FetchType.LAZY)
    @OnDelete(action = OnDeleteAction.RESTRICT)
    @JoinColumn(name = "MERGED_INTO_USER_ID")
    private User mergedIntoUser;

}