package com.telmed.api.auth.repo;
import java.util.Optional;
import com.telmed.api.auth.model.RegStats;
import org.springframework.data.jpa.repository.JpaRepository;


public interface RegStatsRepository extends JpaRepository<RegStats, String> {
    @SuppressWarnings("null")
    Optional<RegStats> findById(String id);
}

