package com.telmed.api.repo;
import java.util.Optional;

import com.telmed.api.repo.model.RegStats;
import org.springframework.data.jpa.repository.JpaRepository;


public interface RegStatsRepository extends JpaRepository<RegStats, String> {
    @SuppressWarnings("null")
    Optional<RegStats> findById(String id);
}

