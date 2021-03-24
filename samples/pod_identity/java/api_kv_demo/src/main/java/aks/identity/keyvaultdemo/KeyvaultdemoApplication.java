package aks.identity.keyvaultdemo;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@SpringBootApplication
public class KeyvaultdemoApplication {

	public static void main(String[] args) {
		SpringApplication.run(KeyvaultdemoApplication.class, args);
	}

	@Value("${javasecret}")
	private String javasecret = "defaultValue\n";
	
	@GetMapping("/")
	public String get() {
		return javasecret;
	}


	public void run(String... varl) throws Exception {
		System.out.println(String.format("\nConnection String stored in Azure Key Vault:\n%s\n",javasecret));
	}
}
