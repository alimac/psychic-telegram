# parser.rb

parser.rb is a Ruby script that ingests CSV files and normalizes them (see Notes for details).

## Requirements

- Ruby (developed with version 2.4.2 installed via [homebrew](https://www.ruby-lang.org/en/documentation/installation/#homebrew))
- `activesupport` gem (`gem install activesupport`)

## Usage

Run script using `ruby parser.rb`, and pass the input CSV filename as an argument:

``` bash
ruby parser.rb input.csv
```

The normalized output is printed to terminal, and also saved to `output.csv`.

## Normalization

* [x] The entire CSV is in the UTF-8 character set.
* [x] The Timestamp column should be formatted in ISO-8601 format.
* [x] The Timestamp column should be assumed to be in US/Pacific time;
  please convert it to US/Eastern.
* [x] All ZIP codes should be formatted as 5 digits. If there are less
  than 5 digits, assume 0 as the prefix.
* [x] All name columns should be converted to uppercase. There will be
  non-English names.
* [x] The Address column should be passed through as is, except for
  Unicode validation. Please note there are commas in the Address
  field; your CSV parsing will need to take that into account. Commas
  will only be present inside a quoted string.
* [x] The columns `FooDuration` and `BarDuration` are in HH:MM:SS.MS
  format (where MS is milliseconds); please convert them to a floating
  point seconds format.
* [x] The column "TotalDuration" is filled with garbage data. For each
  row, please replace the value of TotalDuration with the sum of
  FooDuration and BarDuration.
* [ ] The column "Notes" is free form text input by end-users; please do
  not perform any transformations on this column. If there are invalid
  UTF-8 characters, please replace them with the Unicode Replacement
  Character.

## Notes

- There are no tests. :fearful:
- Using `CSV.parse()` results in a row error if _any_ of the fields are
unparseable, instead of replacing invalid or undefined characters.
