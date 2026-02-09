def detect(config, services):
    """
    Detects if the transformer should be applied.
    Returns a list of artifacts if detected.
    """
    detected_artifacts = []
    for service_name, service in services.items():
        # Example logic: detect any service
        detected_artifacts.append({
            "name": service_name,
            "type": "CustomHelmArtifact",
            "configs": {
                "ServiceName": service_name
            }
        })
    return detected_artifacts

def transform(input_artifacts, output_artifacts):
    """
    Performs the transformation logic.
    """
    path_mappings = []
    for artifact in input_artifacts:
        if artifact["type"] == "CustomHelmArtifact":
            service_name = artifact["configs"]["ServiceName"]
            # Map a local template directory to the output
            path_mappings.append({
                "type": "Template",
                "sourcePath": "templates/helm-chart",
                "destinationPath": "charts/" + service_name,
                "templateContext": {
                    "ServiceName": service_name
                }
            })
    return path_mappings, []
