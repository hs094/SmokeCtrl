package io.person.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RegStatsRepository regStatsRepository;

    @Transactional
    public List<String> saveUser(User user) {
        List<String> response = new ArrayList<>();
        if (userRepository.findByLoginid(user.getLoginid()) != null) {
            response.add("409");
            response.add("Error !");
            response.add("A user with the same loginid already exists.");
            return response;
        }
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
        userRepository.save(user);
        response.add("200");
        response.add("Success !");
        response.add("User Successfully registered with ID: " + userid + ".");
        return response;
    }
}
