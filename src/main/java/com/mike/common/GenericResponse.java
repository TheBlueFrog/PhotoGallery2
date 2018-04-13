package com.mike.common;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by mike on 6/9/2017.
 */
public class GenericResponse {

    private String name = "";
    public String getName() {
        return name;
    }

    private String status;
    public String getStatus() { return status; }

    public GenericResponse setStatus(String status) {
        this.status = status;
        return this;
    }

    private List<String> list = new ArrayList<>();
    public List<String> getList() {
        return list;
    }

    public GenericResponse(String name, String status) {
        this.name = name;
        this.status = status;
    }

    public GenericResponse add(String s) {
        list.add(s);
        return this;
    }

}
