# Requirements
# * git
# * bash
# * shasum
# * ghr: https://github.com/tcnksm/ghr
# * $TRAVIS_JOB_ID
# * $TRAVIS_COMMIT

# Get current commit messsage
# (NOTE: Don't use Travis variables to reduce dependent)
commit_message = `git log --format=%B -n 1 HEAD`

match = commit_message.match(%r{#\[(.*?)\]})
if match.nil?
  STDERR.puts("[WARN] Repository not found")
  STDERR.puts("[HELP] You can commit with message like '#[nwtgck-piping-server] Update to 0.9.2'")
  exit(0)
end

# Get repo name like 'nwtgck/piping-server'
repo_name = match[1]

dir_path = File.join("repos", repo_name)

if !File.directory?(dir_path)
  STDERR.puts("[ERROR] Directory, '#{dir_path}' not found")
  exit(1)
end

puts("[INFO] Repository #{repo_name} is building...")

Dir.chdir(dir_path){
  system("pwd")
  system("bash", "-xue", "build.bash")
  if !File.directory?("dist")
    STDERR.puts("[ERROR] '#{File.join(dir_path, "dist")}' directory not found")
    STDERR.puts("[HELP] You should create 'dist' directory including files to publish")
    exit(1)
  end
  files_sha256 = ""
  Dir.chdir("dist"){
    # Calculate SHA256 of files
    files_sha256 = `shasum -a 256 *`
    sha_bar = "================= SHA256 (#{repo_name}) ================="
    puts(sha_bar)
    # Print SHAN256
    puts(files_sha256)
    puts("=" * sha_bar.size)
    # Save as file in dist
    File.write("FILES_SHA256.txt", files_sha256)
  }
  # Travis Job URL
  travis_job_url = "https://travis-ci.com/nwtgck/docker-repository/jobs/#{ENV["TRAVIS_JOB_ID"]}"
  # Release message
  release_message = <<EOS
Commit: #{ENV["TRAVIS_COMMIT"]}
Travis CI Job: #{travis_job_url}
SHA256:
#{files_sha256}
EOS
  # Create a tag
  git_tag = "#{repo_name}/#{ENV["TRAVIS_COMMIT"]}"
  # Publish to GitHub Release
  system("ghr", "-b", release_message, git_tag, "dist")
  # Print a message
  puts("[INFO] Released as tag '#{git_tag}'!")
}
