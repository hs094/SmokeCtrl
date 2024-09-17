package io.person.api;

import java.util.List;

public class PagedUserResponse {
    private List<User> users;
    private int totalPages;

    public PagedUserResponse(List<User> users, int totalPages) {
        this.users = users;
        this.totalPages = totalPages;
    }

    public List<User> getUsers() {
        return users;
    }

    public void setUsers(List<User> users) {
        this.users = users;
    }

    public int getTotalPages() {
        return totalPages;
    }

    public void setTotalPages(int totalPages) {
        this.totalPages = totalPages;
    }
}
