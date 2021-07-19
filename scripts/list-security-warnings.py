import argparse
import json
import subprocess


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--image',
                        dest='image',
                        action='store',
                        help='Image name',
                        required=True)

    args = parser.parse_args()

    command = ["docker", "scan", "--accept-license", "--json", args.image]

    res = subprocess.run(command, stdout=subprocess.PIPE)
    parsed_json = json.loads(res.stdout)

    seen_vulnerabilities = []
    for vulnerability in parsed_json["vulnerabilities"]:
        if vulnerability["title"] not in seen_vulnerabilities:
            seen_vulnerabilities.append(vulnerability["title"])
            print(vulnerability["title"])


if __name__ == "__main__":
    main()
