from src.extract.fetch_matches import run_extraction
from src.transform.clean_matches import run_transformation
from src.load.load_to_postgres import run_load


def main():
    raw_file_path = run_extraction()

    if raw_file_path is None:
        print("Pipeline stopped: extraction failed.")
        return

    processed_file_path = run_transformation(raw_file_path)

    run_load(processed_file_path)

    print("Pipeline completed successfully.")


if __name__ == "__main__":
    main()