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
@Table(name = "OBJECTION")
public class Objection {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID", nullable = false)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @OnDelete(action = OnDeleteAction.RESTRICT)
    @JoinColumn(name = "LIABILITY_ID", nullable = false)
    private Liability liability;

    @Column(name = "SUBMISSION_DATE", nullable = false)
    private LocalDate submissionDate;

    @Column(name = "PROTOCOL_NUMBER", nullable = false)
    private String protocolNumber;

    @Column(name = "ATTACHMENT")
    private byte[] attachment;

    @Column(name = "LATE_JUSTIFICATION", length = 4000)
    private String lateJustification;

    @Column(name = "RESULT", length = 30)
    private String result;

    @Column(name = "DECISION_NUMBER")
    private String decisionNumber;

    @Column(name = "DECISION_DATE")
    private LocalDate decisionDate;

    @Column(name = "NEW_ASSESSMENT_DECISION_ACT_NUMBER")
    private String newAssessmentDecisionActNumber;

    @Column(name = "NEW_ASSESSMENT_ISSUANCE_DATE")
    private LocalDate newAssessmentIssuanceDate;

    @Column(name = "NEW_AMOUNT", precision = 15, scale = 2)
    private BigDecimal newAmount;

}