import 'package:flutter/material.dart';

import '../models/episode.dart';
import '../models/project.dart';
import '../models/sequence.dart';
import '../services/project.dart';
import '../widgets/project_card.dart';
import 'episodes.dart';
import 'planning.dart';
import 'sequences.dart';
import 'shots.dart';

enum ProjectsPage { projects, episodes, sequences, shots, planning }

class Projects extends StatefulWidget {
  const Projects({super.key});

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  ProjectsPage page = ProjectsPage.projects;

  bool requestCompleted = false;
  late bool requestSucceeded;
  late List<Project> projects;

  late Project selectedProject;
  late Episode selectedEpisode;
  late Sequence selectedSequence;

  @override
  void initState() {
    super.initState();
    getProjects();
  }

  @override
  Widget build(BuildContext context) {
    switch (page) {
      case ProjectsPage.projects:
        if (!requestCompleted) {
          return Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                CircularProgressIndicator(),
              ],
            ),
          );
        } else if (requestSucceeded) {
          if (projects.isNotEmpty) {
            return Expanded(
                child: Column(
              children: <ProjectCard>[
                for (Project project in projects)
                  ProjectCard(
                    project: project,
                    openEpisodes: () {
                      setState(() {
                        selectedProject = project;
                        page = ProjectsPage.episodes;
                      });
                    },
                    openPlanning: () {
                      setState(() {
                        selectedProject = project;
                        page = ProjectsPage.planning;
                      });
                    },
                  )
              ],
            ));
          } else {
            return Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Text('No projects.'),
                ],
              ),
            );
          }
        } else {
          return Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Text('Request failed.'),
              ],
            ),
          );
        }
      case ProjectsPage.episodes:
        return Episodes(
          projectId: selectedProject.id,
          openSequences: (Episode episode) {
            setState(() {
              selectedEpisode = episode;
              page = ProjectsPage.sequences;
            });
          },
        );
      case ProjectsPage.sequences:
        return Sequences(
          sequences: selectedEpisode.sequences,
          openShots: (Sequence sequence) {
            setState(() {
              selectedSequence = sequence;
              page = ProjectsPage.shots;
            });
          },
        );
      case ProjectsPage.shots:
        return Shots(shots: selectedSequence.shots);
      case ProjectsPage.planning:
        return Planning(project: selectedProject);
    }
  }

  Future<void> getProjects() async {
    final List<dynamic> result = await ProjectService().getProjects();
    setState(() {
      requestCompleted = true;
      requestSucceeded = result[0] as bool;
      projects = result[1] as List<Project>;
    });
  }
}
