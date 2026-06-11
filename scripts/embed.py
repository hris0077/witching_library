from flask import Flask, request, jsonify
from sentence_transformers import SentenceTransformer

import subprocess

app = Flask(__name__)

@app.route('/embedding', methods=['POST'])
def generate_embedding():
    sentences = request.json['payload']
    model = SentenceTransformer("all-MiniLM-L6-v2")
    embeddings = model.encode(sentences)
    return jsonify({"embedding":embeddings.tolist()}), 200

if __name__ == '__main__':
    app.run(debug=True, host='127.0.0.1', port=5000)
    