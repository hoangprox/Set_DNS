@echo off
powershell -Command "Start-Process powershell -Verb runAs -ArgumentList 'irm https://raw.githubusercontent.com/hugle2012/win-network-config/main/install.ps1 | iex'"
