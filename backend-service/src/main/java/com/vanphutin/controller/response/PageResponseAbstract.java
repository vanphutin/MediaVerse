package com.vanphutin.controller.response;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

@Getter
@Setter
public class PageResponseAbstract implements Serializable {
    public int pageNumber;
    public int pageSize;
    public int totalPage;
    public int totalElements;
}
