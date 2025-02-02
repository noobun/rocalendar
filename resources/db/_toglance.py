import json
import argparse
import os

parser = argparse.ArgumentParser(
    prog='_toGlance',
    description='Read the main json and create a strip glance version',
    epilog='v0.0.1')

parser.add_argument('-i', '--input')

args = parser.parse_args()

print(f"Try to open main json file ({args.input})...")
try:
    with open(args.input, "r") as i:
        database = json.load(i)
except Exception as e:
    print(e)
print("\tDone!")

payload_glance = []
payload_main = []
print(f"Parse database...")
for month in database:
    last = month["last"]
    name = month["month"]
    days = {}
    for week in month["weeks"].items():
        for day in week[1]["days"].items():
            days[day[0]] = {
                "name": day[1]["name"]+" "+day[1]["desc"],
                "free": day[1]["free"],
                "cross": day[1]["cross"]
            }

    payload_main.append(month)
    payload_glance.append({
        "name": name,
        "last": last,
        "days": days
    })
print("\tDone!")

print(f"Write output to the file (/glance)...")
dirname = os.path.dirname(os.path.abspath(args.input))
for month in payload_glance:
    targetpath = os.path.join(dirname, f"glance/{month['name']}.json")
    print(targetpath)
    with open(targetpath, "w") as o:
        json.dump(month, o, indent=4)
print("\tDone!")

print(f"Write output to the file (/main)...")
dirname = os.path.dirname(os.path.abspath(args.input))
for month in payload_main:
    targetpath = os.path.join(dirname, f"main/{month['month']}.json")
    print(targetpath)
    with open(targetpath, "w") as o:
        json.dump(month, o, indent=4)
print("\tDone!")
