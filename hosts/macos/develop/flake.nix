# 1) Kopiere diese flake.nix in deinen Projektordner
# 2) Betritt die nix-shell mit 'nix develop'
# (automatisiert) 3) Erstelle das venv: 'python -m venv .venv'
# (automatisiert) 4) Aktiviere das venv 'source .venv/bin/activate'
# 5) installiere pakete mit pip 'pip install pandas jupyterlab requests'
# 6) Du verlässt die Umgebung mit dem Standard-Befehl zum Beenden einer Shell: exit

# ./flake.nix
{
  description = "Eine professionelle Python-Entwicklungsumgebung";

  # 1. EINGÄNGE: Definiert, woher der Code kommt (hier: nixpkgs).
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  # 2. AUSGÄNGE: Definiert, was diese Flake bereitstellt (hier: eine devShell).
  outputs = { self, nixpkgs }:
    let
      # Definiert das System. Passen Sie dies bei Bedarf an.
      # "aarch64-darwin" für Apple Silicon (M1/M2/M3)
      # "x86_64-darwin" für Intel-basierte Macs
      system = "aarch64-darwin";

      # Erstellt einen Verweis auf das nixpkgs-Set für das definierte System.
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      # Definiert die Entwicklungsumgebung (Development Shell).
      devShells.${system}.default = pkgs.mkShell {

        shell = pkgs.zsh;

        # Werkzeuge, die in der Shell verfügbar sein sollen
        buildInputs = with pkgs; [
          # 1. DEIN PYTHON-INTERPRETER
          # Wählen Sie eine Version aus.
          python313

          # 2. STANDARD-WERKZEUGE FÜR CODE-QUALITÄT
          ruff         # Linter, Formatter und Import-Sortierer
          black        # Klassischer Code-Formatter
          mypy         # Statische Typ-Prüfung

          # 3. BUILD-TOOLS (für Python-Pakete, die kompiliert werden müssen)
          gcc
          pkg-config

          # 4. ALLGEMEINE ENTWICKLER-TOOLS
          git
          poetry       # Modernes Tool zur Verwaltung von Python-Abhängigkeiten
          pre-commit   # Nützlich, um Hooks vor jedem Commit auszuführen
        ];

        # Shell-Befehle, die bei `nix develop` automatisch ausgeführt werden
        shellHook = ''
          # Willkommensnachricht zur Orientierung
          echo "✅ Python-Entwicklungsumgebung (Python ${pkgs.python313.version}) ist aktiv."

          # Automatisches Erstellen und Aktivieren des venv
          if [ ! -d ".venv" ]; then
            echo "🐍 Erstelle virtuelles Environment im Ordner .venv..."
            python -m venv .venv
          fi
          source .venv/bin/activate

          # Beispiel für eine projektspezifische Umgebungsvariable
          export MY_API_KEY="dein_schlüssel_hier"

          # Installiere pre-commit Hooks, falls konfiguriert
          # (Erfordert eine .pre-commit-config.yaml Datei im Projekt)
          if [ -f ".pre-commit-config.yaml" ]; then
            pre-commit install
          fi
        '';
      };
    };
}
