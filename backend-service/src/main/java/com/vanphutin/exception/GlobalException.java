package com.vanphutin.exception;

import com.vanphutin.controller.response.ErrorResponse;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.ExampleObject;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import jakarta.validation.ConstraintViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.context.request.WebRequest;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import static org.springframework.http.HttpStatus.BAD_REQUEST;
import static org.springframework.http.MediaType.APPLICATION_JSON_VALUE;
import static org.springframework.http.HttpStatus.NOT_FOUND;

@RestControllerAdvice
public class GlobalException {

    // =============================================
    // 400 - BAD REQUEST
    // =============================================

    @ExceptionHandler({
            MethodArgumentNotValidException.class,
            ConstraintViolationException.class,
            MissingServletRequestParameterException.class
    })
    @ResponseStatus(BAD_REQUEST)
    @ApiResponses(value = {
            @ApiResponse(
                    responseCode = "400",
                    description = "Bad Request",
                    content = @Content(
                            mediaType = APPLICATION_JSON_VALUE,
                            schema = @Schema(implementation = ErrorResponse.class),
                            examples = @ExampleObject(
                                    name = "400 Bad Request Example",
                                    summary = "Handle exception when request data is invalid",
                                    value = """
                                        {
                                          "timestamp": "2024-04-07T11:38:57.000+00:00",
                                          "status": 400,
                                          "path": "/api/v1/...",
                                          "error": "Invalid Payload",
                                          "message": "Validation failed",
                                          "errors": {
                                            "username": "username must not be blank",
                                            "email": "email is invalid"
                                          }
                                        }
                                        """
                            )
                    )
            )
    })
    public ErrorResponse handleValidationExceptions(Exception e, WebRequest request) {

        ErrorResponse error = new ErrorResponse();
        error.setTimestamp(new Date());
        error.setStatus(BAD_REQUEST.value());
        error.setError("Invalid Payload");
        error.setPath(request.getDescription(false).replace("uri=", ""));

        Map<String, String> validationErrors = new HashMap<>();

        // Case 1: @Valid on @RequestBody → MethodArgumentNotValidException
        if (e instanceof MethodArgumentNotValidException ex) {
            ex.getBindingResult().getFieldErrors().forEach(err ->
                    validationErrors.put(err.getField(), err.getDefaultMessage())
            );
            error.setMessage("Validation failed");
        }

        // Case 2: @Valid on @PathVariable / @RequestParam → ConstraintViolationException
        else if (e instanceof ConstraintViolationException ex) {
            ex.getConstraintViolations().forEach(err -> {

                String field = err.getPropertyPath().toString();

                // Rút gọn path: getUserDetails.userId -> userId
                if (field.contains(".")) {
                    field = field.substring(field.lastIndexOf('.') + 1);
                }

                validationErrors.put(field, err.getMessage());
            });
            error.setMessage("Constraint violation");
        }


        // Case 3: Thiếu @RequestParam
        else if (e instanceof MissingServletRequestParameterException ex) {
            validationErrors.put(ex.getParameterName(), "Missing required parameter");
            error.setMessage("Missing request parameter");
        }

        error.setErrors(validationErrors);
        return error;
    }


    // =============================================
    // 404 - RESOURCE NOT FOUND
    // =============================================

    @ExceptionHandler(ResourceNotFoundException.class)
    @ResponseStatus(NOT_FOUND)
    @ApiResponses(value = {
            @ApiResponse(
                    responseCode = "404",
                    description = "Not Found",
                    content = @Content(
                            mediaType = APPLICATION_JSON_VALUE,
                            schema = @Schema(implementation = ErrorResponse.class),
                            examples = @ExampleObject(
                                    name = "404 Example",
                                    summary = "Resource not found example",
                                    value = """
                                        {
                                          "timestamp": "2023-10-19T06:07:35.321+00:00",
                                          "status": 404,
                                          "path": "/api/v1/user/1",
                                          "error": "Not Found",
                                          "message": "User not found"
                                        }
                                        """
                            )
                    )
            )
    })
    public ErrorResponse handleResourceNotFoundException(
            ResourceNotFoundException e,
            WebRequest request
    ) {
        ErrorResponse error = new ErrorResponse();
        error.setTimestamp(new Date());
        error.setStatus(NOT_FOUND.value());
        error.setError(NOT_FOUND.getReasonPhrase());
        error.setMessage(e.getMessage());
        error.setPath(request.getDescription(false).replace("uri=", ""));

        return error;
    }

}
