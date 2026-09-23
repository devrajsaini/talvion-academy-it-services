import fs from 'fs';

const html = fs.readFileSync('courses.html', 'utf8');

const regex = /<div class="course-tooltiper" id="([^"]+)">([\s\S]*?)<\/div>\s*<\/div>\s*<\/div>/g;
let match;
let i = 1;
while ((match = regex.exec(html)) !== null) {
  const id = match[1];
  const block = match[2];
  const category = (block.match(/rel="tag">([^<]+)<\/a>/) || [])[1];
  const author = (block.match(/class="author-info[^>]*>([\s\S]*?)<span class="course-rating/i) || [])[1]?.replace(/\s+/g, ' ').trim();
  const rating = (block.match(/<span class="course-rating[^>]*>([\s\S]*?)<\/span>/i) || [])[1]?.replace(/<[^>]+>/g, ' ').replace(/\s+/g, ' ').trim();
  const price = (block.match(/<span class="price">([\s\S]*?)<\/span>/i) || [])[1]?.replace(/<[^>]+>/g, ' ').replace(/\s+/g, ' ').trim();
  const lessons = (block.match(/class="course-lessons">([\s\S]*?)<\/span>/i) || [])[1]?.replace(/\s+/g, ' ').trim();
  const students = (block.match(/class="course-user">([\s\S]*?)<\/span>/i) || [])[1]?.replace(/\s+/g, ' ').trim();
  const skills = (block.match(/class="course-skill[^>]*>([\s\S]*?)<\/div>/i) || [])[1]?.replace(/<[^>]+>/g, ' ').replace(/\s+/g, ' ').trim();
  const link = (block.match(/href="([^"]+)"[^>]*>View course detail/i) || [])[1];
  
  console.log(`[${i}] ID: ${id} | Cat: ${category} | Price: ${price} | Author: ${author} | Lessons: ${lessons} | Students: ${students} | Link: ${link}`);
  console.log(`    Skills: ${skills}`);
  i++;
}
