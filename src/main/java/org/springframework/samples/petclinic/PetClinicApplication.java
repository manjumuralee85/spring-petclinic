package org.springframework.samples.petclinic;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

/**
 * Spring Boot PetClinic Application
 * 
 * Converted from Spring Framework 7.0 to Spring Boot 3.x
 * Supports both JAR (embedded Tomcat) and WAR (external container) deployment
 */
@SpringBootApplication
public class PetClinicApplication extends SpringBootServletInitializer {

    public static void main(String[] args) {
        SpringApplication.run(PetClinicApplication.class, args);
    }

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        // For WAR deployment
        return application.sources(PetClinicApplication.class);
    }
}
