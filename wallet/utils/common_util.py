import json

def load_json(data):
    if isinstance(data, str):
        return json.loads(data)
    elif isinstance(data, bytes):
        return json.loads(data.decode('utf-8'))
    else:
        return json.loads("%s" % data)


