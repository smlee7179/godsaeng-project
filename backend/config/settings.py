import json, os
BASE_DIR = os.path.dirname(__file__)
SECRET_FILE = os.path.join(BASE_DIR, "secrets.json")

def load_secrets():
    if not os.path.exists(SECRET_FILE):
        raise FileNotFoundError(
            f"⚙️ secrets.json 파일이 없습니다. backend/config 경로에 생성하세요."
        )
    with open(SECRET_FILE, "r") as f:
        return json.load(f)

secrets = load_secrets()
