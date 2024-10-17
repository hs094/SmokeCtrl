package com.telmed.api.Repository;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;

@Setter
@Getter
@Entity
public class RegStats {
    @Id
    private String id;
    private LocalDate date;
    private Integer count;

    public void incrementCount() {
        if (this.count == null) {
            this.count = 1;
        } else {
            this.count++;
        }
    }
}
