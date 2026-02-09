def detect(config, services):
    detected_artifacts = []
    if not services: return []
    for service_name, service in services.items():
        detected_artifacts.append({
            "name": service_name,
            "type": "CustomHelmArtifact",
            "configs": {
                "ServiceName": service_name
            }
        })
    return detected_artifacts

def transform(input_artifacts, output_artifacts):
    path_mappings = []
    for artifact in input_artifacts:
        if artifact["type"] == "CustomHelmArtifact":
            service_name = artifact["name"]
            path_mappings.append({
                "type": "Template",
                "sourcePath": "templates/helm-chart",
                "destinationPath": "charts/" + service_name,
                "templateContext": {
                    "ServiceName": service_name
                }
            })
    return path_mappings, []
