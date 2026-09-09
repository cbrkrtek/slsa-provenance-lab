import json

with open("../evidence/json/real-provenance.json") as f:
    prov = json.load(f)

prov["predicate"]["invocation"]["configSource"]["uri"] = "git+https://github.com/attacker/evil-repo"
prov["predicate"]["invocation"]["configSource"]["digest"]["sha1"] = "deadbeefdeadbeefdeadbeefdeadbeefdeadbeef"

with open("../evidence/json/forged-provenance.json", "w") as f:
    json.dump(prov, f, indent=2, ensure_ascii=False)
    f.write("\n")

print("done")
