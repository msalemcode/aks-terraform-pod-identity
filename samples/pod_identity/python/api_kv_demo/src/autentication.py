import os
from datetime import datetime
from azure.keyvault import KeyVaultClient, KeyVaultAuthentication
from msrestazure.azure_active_directory import MSIAuthentication
from flask import Flask
app = Flask(__name__)

def kv_get_secret(secret_id):
    client = KeyVaultClient(get_kv_credentials())
    value_id = client.get_secret(os.getenv('KEYVAULT_URI'), secret_id, "")  
    if(value_id is None):
            return ("")
    else:
        print('Geting Secret %s with value %s' % (secret_id,value_id.value))
        return (value_id.value)

def get_kv_credentials():
    return MSIAuthentication(resource='https://vault.azure.net')

@app.route('/')
def hello_world():
    try:
        return kv_get_secret("pythonsecret")
    except Exception as err:
        return str(err)


@app.route('/ping')
def ping():
    return "Hello world"



if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
