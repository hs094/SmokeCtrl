package com.telmed.api.service;

import com.telmed.api.repo.model.User;
import lombok.Getter;
import org.springframework.stereotype.Component;

@Component
@Getter
public class PromptComponent {
    User user;
    String prompt;
}
