# Requirements
# * ghr: https://github.com/tcnksm/ghr

# TODO: Hard code
repo_name="nwtgck/piping-server"
dir_path = File.join("repos", repo_name)

Dir.chdir(dir_path){
  system("pwd")
  system("bash", "-xue", "build.bash")
  # TODO: Check whether dist exists
  # Travis Job URL
  travis_job_url = "https://travis-ci.com/nwtgck/docker-repository/jobs/#{ENV["TRAVIS_JOB_ID"]}"
  # Release message
  release_message = "Travis CI Job: #{travis_job_url}"
  # Create a tag
  git_tag = "#{repo_name}/#{ENV["TRAVIS_COMMIT"]}"
  # Publish to GitHub Release
  system("ghr", "-b", release_message, git_tag, "dist")
  # Print a message
  puts("Released as tag '#{git_tag}'!")
}
