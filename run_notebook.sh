#!/bin/bash
# Quick start script for the AI File Sorter notebook

echo "🚀 Starting AI File Sorter Notebook Environment"
echo "=============================================="

# Check if Python is available
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is required but not installed"
    exit 1
fi

# Run setup if needed
if ! python3 -c "import jupyter" 2>/dev/null; then
    echo "📦 Installing dependencies..."
    python3 setup_notebook.py
fi

# Start Jupyter notebook
echo "🎯 Starting Jupyter notebook..."
echo "📝 Your notebook: Aifiles.ipynb"
echo "🌐 Opening in browser..."

jupyter notebook Aifiles.ipynb