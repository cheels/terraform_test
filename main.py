# This is a sample Python script.

# Press Shift+F10 to execute it or replace it with your code.
# Press Double Shift to search everywhere for classes, files, tool windows, actions, and settings.
import logging
import random

from python_terraform import Terraform
import hazelcast
import unittest


def map_put_get_and_verify(test_map_element):
    print("Put get to map and verify")
    test_map_element.clear()
    while test_map_element.size() < 20:
        random_key = random.randint(1, 100000)
        try:
            test_map_element.put("key" + str(random_key), "value" + str(random_key))
        except:
            logging.exception("Put operation failed!")
    print(test_map_element.size())


if __name__ == "__main__":
    tf = Terraform(working_dir='./FirstTest')
    tf.init()
    tf.plan()
    output_of_apply = tf.apply(skip_plan=True, var={'instance_name': 'Ali_Test'})
    # result = tf.apply(skip_plan=True)
    # tf.destroy(working_dir='./modules')
    result = tf.output()
    public_ip = result['public_ip']['value']
    client = hazelcast.HazelcastClient(
        cluster_members=[
            public_ip
        ]
    )
    test_map = client.get_map("test_map").blocking()
    map_put_get_and_verify(test_map)

