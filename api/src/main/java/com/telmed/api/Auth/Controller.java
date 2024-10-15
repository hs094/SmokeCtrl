package com.telmed.api.Auth;

import com.telmed.api.Repository.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.beans.factory.annotation.Autowired;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

@RestController
@RequestMapping("/auth")
public class Controller {

    private final UserRepository userRepository;
    private final RegStatsRepository regStatsRepository;

    // Constructor-based Dependency Injection
    @Autowired
    public Controller(UserRepository userRepository, RegStatsRepository regStatsRepository) {
        this.userRepository = userRepository;
        this.regStatsRepository = regStatsRepository;
    }

    @PostMapping("/signup")
    public ResponseEntity<List<String>> signUpUser(@RequestBody User user) {
        List<String> response = new ArrayList<>();

        // Check if user with the same loginId exists
        if (userRepository.findUserByLoginid(user.getLoginid()) != null) {
            response.add("409");
            response.add("Error !");
            response.add("A user with the same Login-ID already exists.");
            return new ResponseEntity<>(response, HttpStatus.CONFLICT);
        }

        LocalDate today = LocalDate.now();
        RegStats stats = regStatsRepository.findById("latest").orElse(new RegStats());

        // Update registration statistics
        if (stats.getDate() == null || !stats.getDate().equals(today)) {
            stats.setDate(today);
            stats.setCount(1);
        } else {
            stats.incrementCount();
        }
        stats.setId("latest");
        regStatsRepository.save(stats);

        // Generate user ID based on today's date and stats count
        String userId = today.format(DateTimeFormatter.ofPattern("ddMMyyyy")) + "_" + stats.getCount();
        user.setUserid(userId);  // Set user ID
        userRepository.save(user);

        // Return success response
        response.add("200");
        response.add("Success !");
        response.add("User Successfully registered with ID: " + userId + ".");
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @PostMapping("/login")
    public ResponseEntity<?> loginUser(@RequestBody User user) {
        User oldUser = userRepository.findUserByLoginidAndPwd(user.getLoginid(), user.getPwd());
        if (oldUser == null) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
        return new ResponseEntity<>(oldUser, HttpStatus.OK);
    }
}
