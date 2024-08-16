package io.person.api;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

public interface RegStatsRepository extends JpaRepository<RegStats, String> {
    @SuppressWarnings("null")
    Optional<RegStats> findById(String id);
}
