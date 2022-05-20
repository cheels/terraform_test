from python_terraform import Terraform
from flask import Flask, jsonify

app = Flask("provisioner")


@app.route("/createServer")
def create_cluster():
    tf = Terraform(working_dir='./FirstTest')
    tf.init()
    tf.plan()
    tf.apply(skip_plan=True, var={'instance_name': 'Ali_Test'})
    result = tf.output()
    public_ip = result['public_ip']['value']
    return jsonify(
        publicIp=public_ip
    )

