def detect(config, services):
    """
    detect function is called with the config and the services detected so far.
    """
    detected_artifacts = []
    # If no services were detected by other transformers, 'services' might be empty.
    # However, since we have 'directoryDetectedAsService: true', move2kube should 
    # have created a service for the directories.
    
    # Let's try to detect based on any service provided
    if not services:
        # Fallback or debug: if services is empty, it means nothing was detected yet.
        return []

    for service_name, service in services.items():
        # Let's be less strict for debugging
        tech = "java" 
        
        # 'service' in detect is a list of artifacts
        for artifact in service:
            if artifact.get("type") == "MavenPom":
                tech = "java"
            elif artifact.get("type") == "NodejsPackageJson":
                tech = "nodejs"

        detected_artifacts.append({
            "name": service_name,
            "type": "CustomDockerfileArtifact",
            "configs": {
                "ServiceName": service_name,
                "Technology": tech
            }
        })
    return detected_artifacts

def transform(input_artifacts, output_artifacts):
    path_mappings = []
    for artifact in input_artifacts:
        if artifact["type"] == "CustomDockerfileArtifact":
            service_name = artifact["name"] # Use .name
            tech = artifact["configs"]["Technology"]
            
            source_template = "templates/Dockerfile.java"
            if tech == "nodejs":
                source_template = "templates/Dockerfile.nodejs"
            elif tech == "springboot":
                source_template = "templates/Dockerfile.springboot"
            
            path_mappings.append({
                "type": "Template",
                "sourcePath": source_template,
                "destinationPath": "source/Dockerfile",
                "templateContext": {
                    "ServiceName": service_name,
                    "Technology": tech
                }
            })
    return path_mappings, []
