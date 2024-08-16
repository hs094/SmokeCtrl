package io.person.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RegStatsRepository regStatsRepository;

    @Transactional
    public User saveUser(User user) {
        LocalDate today = LocalDate.now();
        RegStats stats = regStatsRepository.findById("latest").orElse(new RegStats());
        
        if (stats.getDate() == null || !stats.getDate().equals(today)) {
            stats.setDate(today);
            stats.setCount(1);
        } else {
            stats.incrementCount();
        }        
        stats.setId("latest");
        regStatsRepository.save(stats);
        String userid = today.format(DateTimeFormatter.ofPattern("ddMMyyyy")) + "_" + stats.getCount();
        user.setUserid(userid);
        return userRepository.save(user);
    }
}
