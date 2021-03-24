using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Azure.Identity;
using Azure.Security.KeyVault.Secrets;
using Microsoft.AspNetCore.Mvc;

namespace  ApiKvDemo.Controllers
{
    [ApiController]
    [Route("/")]
    public class MainController : ControllerBase
    {
        // GET:api/secret
        [HttpGet]
        public ActionResult<string> Get()
        {
            string uri = Environment.GetEnvironmentVariable("KEYVAULT_URI");
            SecretClient client = new SecretClient(new Uri(uri), new DefaultAzureCredential());
            KeyVaultSecret  secret =  client.GetSecret("csharpsecret");
            Console.WriteLine("Found Secret!");
            return secret.Value;
        }
    }
}