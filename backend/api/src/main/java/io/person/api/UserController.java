package io.person.api;

import java.util.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class UserController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private UserService userService;

    @PostMapping("/register")
    public List<String> Register(@RequestBody User user) {
        return userService.saveUser(user);
    }

    @PostMapping("/login")
    public ResponseEntity<User> login(@RequestBody User user) {
        User oldUser = userRepository.findByLoginidAndPwd(user.getLoginid(), user.getPwd());
        if (oldUser == null) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
        return new ResponseEntity<>(oldUser, HttpStatus.OK);
    }

    @PostMapping("/all")
    public ResponseEntity<PagedUserResponse> allUsers(@RequestParam(name = "page", defaultValue = "0") Integer page, @RequestParam(name = "size", defaultValue = "10") Integer size) {
        Pageable pageable = PageRequest.of(page, size);
        Page<User> pageUser = userRepository.findAll(pageable);
        PagedUserResponse response = new PagedUserResponse(pageUser.getContent(), pageUser.getTotalPages());
        return new ResponseEntity<>(response, HttpStatus.OK);
    }
}
