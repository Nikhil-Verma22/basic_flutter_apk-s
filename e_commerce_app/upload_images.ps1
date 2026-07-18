$bucketUrl = "https://dfdojjaywrpvgspchtzi.supabase.co/storage/v1/object/product_images/"
$key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRmZG9qamF5d3JwdmdzcGNodHppIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzU3ODk0OTQsImV4cCI6MjA5MTM2NTQ5NH0.kW0DYnAxDrsKdChkdD0iz5xyyZd3uKCSbvVD1TWRBoA"
$headers = @{
    "Authorization" = "Bearer $key"
    "Content-Type"  = "image/png"
}

$files = @{
    "tshirt.png"   = "C:\Users\Lenovo\.gemini\antigravity\brain\11471f51-aa18-424a-b7e4-3dc267e3a004\tshirt_image_1775829038334.png"
    "pants.png"    = "C:\Users\Lenovo\.gemini\antigravity\brain\11471f51-aa18-424a-b7e4-3dc267e3a004\pants_image_1775829057662.png"
    "watch.png"    = "C:\Users\Lenovo\.gemini\antigravity\brain\11471f51-aa18-424a-b7e4-3dc267e3a004\watch_image_1775829077364.png"
    "bag.png"      = "C:\Users\Lenovo\.gemini\antigravity\brain\11471f51-aa18-424a-b7e4-3dc267e3a004\bag_image_1775829097123.png"
    "phone.png"    = "C:\Users\Lenovo\.gemini\antigravity\brain\11471f51-aa18-424a-b7e4-3dc267e3a004\phone_image_1775829113905.png"
    "medicine.png" = "C:\Users\Lenovo\.gemini\antigravity\brain\11471f51-aa18-424a-b7e4-3dc267e3a004\medicine_image_1775829130898.png"
}

foreach ($fileName in $files.Keys) {
    $filePath = $files[$fileName]
    $uri = "$bucketUrl$fileName"
    Write-Host "Uploading $fileName..."
    try {
        $result = Invoke-RestMethod -Uri $uri -Method Post -Headers $headers -InFile $filePath
        Write-Host "Success: $($result.Key)"
    } catch {
        Write-Host "Error uploading $fileName"
        Write-Host $_.Exception.Response.StatusCode.value__
        Write-Host $_.ErrorDetails.Message
    }
}
