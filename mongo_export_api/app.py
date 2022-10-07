from flask import Flask, request
from datetime import datetime
from dateutil.relativedelta import relativedelta
import re
import env
import time
import os

vmip = env.LOCAL_IP
secret = env.SECRET
run_path = env.RUN_PATH

app = Flask(__name__)

@app.route("/")
def hello_world():
    return "<p>Hello, World!</p>"

@app.route("/init_work", methods=["POST"])
def init_work():
    if request.values["secret"] != secret:
        return "<p>no auth found</p>"
    
    year_month = request.values["year_month"]

    if not re.findall('\d{4}_\d{2}', year_month):
        return "<p>not correct year_month</p>"
    
    os.system(f'cd {run_path} && bash init_data.sh')
    time.sleep(0.5)
    os.system(f'cd {run_path} && nohup bash run_csv.sh {year_month}_ &')
    return "<p>export sequence started</p>"

@app.route("/init_work_now", methods=["POST"])
def init_work_now():
    if request.values["secret"] != secret:
        return "<p>no auth found</p>"

    year_month = datetime.now().strftime('%Y_%m')
    
    os.system(f'cd {run_path} && bash init_data.sh')
    time.sleep(0.5)
    os.system(f'cd {run_path} && nohup bash run_csv.sh {year_month}_ &')
    return "<p>export sequence started</p>"

@app.route("/init_work_last", methods=["POST"])
def init_work_last():
    if request.values["secret"] != secret:
        return "<p>no auth found</p>"

    year_month = (datetime.now() - relativedelta(months=1)).strftime('%Y_%m')

    os.system(f'cd {run_path} && bash init_data.sh')
    time.sleep(0.5)
    os.system(f'cd {run_path} && nohup bash run_csv.sh {year_month}_ &')
    return "<p>export sequence started</p>"

if __name__ == '__main__':
    app.run(host=vmip, port=8080)