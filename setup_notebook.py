#!/usr/bin/env python3
"""
Setup script for AI File Sorter Jupyter notebook environment
"""

import subprocess
import sys
import os

def install_requirements():
    """Install required packages for the notebook"""
    packages = [
        'jupyter',
        'notebook',
        'ipykernel',
        'PyMuPDF',  # For PDF processing
        'pandas',   # For data analysis
        'matplotlib',  # For visualizations
        'requests'  # For API calls
    ]
    
    for package in packages:
        try:
            subprocess.check_call([sys.executable, '-m', 'pip', 'install', package])
            print(f"✓ Installed {package}")
        except subprocess.CalledProcessError:
            print(f"✗ Failed to install {package}")

def setup_kernel():
    """Setup Jupyter kernel"""
    try:
        subprocess.check_call([sys.executable, '-m', 'ipykernel', 'install', '--user', '--name=aifiles'])
        print("✓ Jupyter kernel setup complete")
    except subprocess.CalledProcessError:
        print("✗ Failed to setup Jupyter kernel")

def main():
    print("Setting up AI File Sorter notebook environment...")
    install_requirements()
    setup_kernel()
    
    print("\n" + "="*50)
    print("Setup complete! To start the notebook:")
    print("1. Run: jupyter notebook")
    print("2. Open: Aifiles.ipynb")
    print("3. Select kernel: aifiles")
    print("="*50)

if __name__ == "__main__":
    main()