from python_terraform import *
from flask import Flask, jsonify, render_template
import os.path

app = Flask("provisioner")
app = Flask(__name__, static_url_path='')


@app.route('/cluster/create/', defaults={'cluster_size': 3})
@app.route('/cluster/create/<int:cluster_size>')
def create_cluster(cluster_size):
    project_path = os.path.dirname(os.path.dirname(__file__))
    tf = Terraform(working_dir=project_path + '/terraform_test/deployment/initial_run')
    tf.init()
    tf.plan()
    tf.apply(skip_plan=True, var={'member_count': cluster_size})
    result = tf.output()
    public_dns = result['aws_members_public_dns']['value']
    return jsonify(
        public_dns=public_dns
    )


@app.route("/cluster/delete")
def destroy_cluster():
    project_path = os.path.dirname(os.path.dirname(__file__))
    tf = Terraform(working_dir=project_path + '/terraform_test/deployment/initial_run')
    tf.apply(destroy=IsFlagged, skip_plan=True, lock=False)
    return jsonify(result="Destroy completed!")


@app.route("/cluster/public-dns")
def get_public_dns():
    tf = Terraform(working_dir=os.path.dirname(os.path.dirname(__file__)) + '/terraform_test/deployment/initial_run')
    result = tf.output()
    if result == {}:
        return jsonify(error="There are no any public DNS. To get the DNS please create the cluster before.")
    else:
        public_dns = result['aws_members_public_dns']['value'][0]
        return jsonify(
            public_dns=public_dns
        )


@app.route('/')
def index():
    return render_template('index.html')
