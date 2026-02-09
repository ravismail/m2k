def detect(config, services):
    detected_artifacts = []
    for service_name, service in services.items():
        # Default technology
        tech = "unknown"
        
        # Check files in the service directory
        # 'service' object contains information about the detected files
        # Alternatively, we can inspect 'service.source.files' if available in the context
        
        # In move2kube, 'services' contains detected artifacts.
        # We can look for specific artifacts like 'MavenPom' or 'NodeJS'
        
        has_pom = False
        has_package_json = False
        is_springboot = False

        # Simple file-based logic (simplified for Starlark context)
        # We check common identifiers for technologies
        if "package.json" in service:
             tech = "nodejs"
        elif "pom.xml" in service:
             tech = "java"
             # If we could read file content, we'd check for spring-boot
             # For now, let's assume we can differentiate by folder structure or artifacts
             pass

    # A more robust way in move2kube is to check the types of artifacts 
    # already detected for the service.
    
    # For this sample, we'll suggest a logic based on 'service' keys
    # or explicitly passed metadata.
    
    for service_name, service in services.items():
        # Example detection logic
        tech = "java" # Default
        if any(f.endswith("package.json") for f in service.get("files", [])):
            tech = "nodejs"
        elif any(f.endswith("pom.xml") for f in service.get("files", [])):
            tech = "java"
            # Optional: deep check for spring-boot if relevant
            # for f in service.get("files", []):
            #    if "spring-boot" in read_file(f): tech = "springboot"

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
            service_name = artifact["configs"]["ServiceName"]
            tech = artifact["configs"]["Technology"]
            
            # Map specific template based on technology
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
