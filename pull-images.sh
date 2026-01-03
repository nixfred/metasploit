#!/bin/bash
# Pull all Docker images for P3N73S7 L4B
# Run this once from terminal before using the Lab UI

echo "🔄 Pulling all lab images (this may take a few minutes)..."
echo ""

cd "$(dirname "$0")"

docker-compose pull

echo ""
echo "✅ Done! All images ready. Run 'lab' to start."
