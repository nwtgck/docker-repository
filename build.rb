# Requirements
# * ghr: https://github.com/tcnksm/ghr

# TODO: Hard code
repo_name="nwtgck/piping-server"
dir_path = File.join("repos", repo_name)

Dir.chdir(dir_path){
  system("pwd")
  system("bash", "-xue", "build.bash")
  # TODO: Check whether dist exists
  files_sha256 = ""
  Dir.chdir("dist"){
    # Calculate SHA256 of files
    files_sha256 = `shasum -a 256 *`
    # Print SHAN256
    puts("SHA256:")
    puts(files_sha256)
    # Save as file in dist
    File.write("FILES_SHA256.txt", files_sha256)
  }
  # Travis Job URL
  travis_job_url = "https://travis-ci.com/nwtgck/docker-repository/jobs/#{ENV["TRAVIS_JOB_ID"]}"
  # Release message
  release_message = <<EOS
Travis CI Job: #{travis_job_url}
SHA256:
#{files_sha256}
EOS
  # Create a tag
  git_tag = "#{repo_name}/#{ENV["TRAVIS_COMMIT"]}"
  # Publish to GitHub Release
  system("ghr", "-b", release_message, git_tag, "dist")
  # Print a message
  puts("Released as tag '#{git_tag}'!")
}
